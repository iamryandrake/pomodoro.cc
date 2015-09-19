defmodule FreeGeoIp do
  import HTTPoison
  @freegeoip_endpoint "https://freegeoip.net/json/"

  def coordinates_for(ip) do
    request(ip)
    |> decode
    |> extract_coordinates
  end

  defp request(ip), do: HTTPoison.get!(@freegeoip_endpoint <> ip)
  defp decode(response), do: Poison.decode!(response.body)
  defp extract_coordinates(geo_info) do
    latitude = Dict.get(geo_info, "latitude", "")
    longitude = Dict.get(geo_info, "longitude", "")
    {latitude, longitude}
  end
end
