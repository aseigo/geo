defmodule Geo.MultiLineStringZ do
  @moduledoc """
  Defines the MultiLineStringZ struct.
  """

  @type t :: %__MODULE__{
          coordinates: [[{number, number, number}]],
          srid: integer,
          properties: map
        }
  defstruct coordinates: [], srid: nil, properties: %{}
end
