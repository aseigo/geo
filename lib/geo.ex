defmodule Geo do
  @moduledoc """
  A collection of GIS functions. Handles conversions to and from WKT, WKB, and GeoJSON for the following geometries:

  * Point
  * PointZ
  * LineString
  * LineStringZ
  * Polygon
  * PolygonZ
  * MultiPoint
  * MulitLineString
  * MulitLineStringZ
  * MultiPolygon
  * MultiPolygonZ
  * GeometryCollection

  ## Examples


  * Encode and decode WKT and EWKT

    ```elixir
    iex(1)> point = Geo.WKT.decode("POINT(30 -90)")
    %Geo.Point{ coordinates: {30, -90}, srid: nil}

    iex(2)> Geo.WKT.encode(point)
    "POINT(30 -90)"

    iex(3)> point = Geo.WKT.decode("SRID=4326;POINT(30 -90)")
    %Geo.Point{coordinates: {30, -90}, srid: 4326}
    ```


  * Encode and decode WKB and EWKB

    ```elixir
    iex(1)> point = Geo.WKB.decode("0101000000000000000000F03F000000000000F03F")
    %Geo.Point{ coordinates: {1.0, 1.0}, srid: nil }

    iex(2)> Geo.WKB.encode(point)
    "00000000013FF00000000000003FF0000000000000"

    iex(3)> point = Geo.WKB.decode("0101000020E61000009EFB613A637B4240CF2C0950D3735EC0")
    %Geo.Point{ coordinates: {36.9639657, -121.8097725}, srid: 4326 }

    iex(4)> Geo.WKB.encode(point)
    "0020000001000010E640427B633A61FB9EC05E73D350092CCF"
    ```

  * Encode and decode GeoJSON

    Geo only encodes and decodes maps shaped as GeoJSON. JSON encoding and decoding must
    be done before and after.

    ```elixir
    #Examples using Poison as the JSON parser

    iex(1)> Geo.JSON.encode(point)
    %{ "type" => "Point", "coordinates" => [100.0, 0.0] }

    iex(2)> point = Poison.decode!("{ \"type\": \"Point\", \"coordinates\": [100.0, 0.0] }") |> Geo.JSON.decode
    %Geo.Point{ coordinates: {100.0, 0.0}, srid: nil }

    iex(3)> Geo.JSON.encode(point) |> Poison.encode!
    "{\"type\":\"Point\",\"coordinates\":[100.0,0.0]}"
    ```

  ## String.Chars type serialization

  By default, the geometry types implement the String.Chars protocol for easy serialization
  using Geo.WKT.encode!/1 to do the serialization to string.

  This can be easily overriden in configuration, however, with a string_chars_impls entry
  in the geo app's configuration. For instance, to prevent all String.Chars ipmlementations
  put the following in the relevant config.exs for your application:

    ```elixir
    config :geo,
      string_chars_impls: false
    ```

  To override just the implementation for Geo.Polygon (or any other type) do the following:

    ```elixir
    config: geo
      string_chars_impls: %{Geo.Polygon => &MyModule.function/1}
    ```

  The default serializer may also be overriden:

    ```elixir
    config :geo,
      string_chars_impls: %{:default => &MyMod.foo/1}
    ```

  And, of course, the approaches may be combined:

    ```elixir
    config :geo,
      string_chars_impls: %{:default => &MyMod.foo/1,
                            Geo.Polygon => &String.length/1}
    ```

  Serializer functions must accept one argument, the geometry data, and return a string.
  """

  @type geometry ::
          Geo.Point.t()
          | Geo.PointZ.t()
          | Geo.PointM.t()
          | Geo.PointZM.t()
          | Geo.LineString.t()
          | Geo.LineStringZ.t()
          | Geo.Polygon.t()
          | Geo.PolygonZ.t()
          | Geo.MultiPoint.t()
          | Geo.MultiLineString.t()
          | Geo.MultiLineStringZ.t()
          | Geo.MultiPolygon.t()
          | Geo.MultiPolygonZ.t()
          | Geo.GeometryCollection.t()

  @type endian :: :ndr | :xdr

  require Geo.Utils
  @before_compile {Geo.Utils, :create_string_chars_impls}
end
