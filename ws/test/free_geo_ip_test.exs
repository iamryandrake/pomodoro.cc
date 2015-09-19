defmodule FreeGeoIpTest do
  use ExUnit.Case, async: false
  import Mock

  test "gets coordinates for ip"  do
    ip = "127.0.0.1"
    with_mock HTTPoison, [get!: &response_freegeoip/1] do
      {lat, lon} = FreeGeoIp.coordinates_for(ip)

      assert called HTTPoison.get!("https://freegeoip.net/json/#{ip}")
      assert lat == 42.123
      assert lon == 12.123
    end
  end

  defp response_freegeoip(_url) do
    %HTTPoison.Response{body: "{\"ip\":\"192.168.11.1\",\"country_code\":\"\",\"country_name\":\"\",\"region_code\":\"\",\"region_name\":\"\",\"city\":\"\",\"zip_code\":\"\",\"time_zone\":\"\",\"latitude\":42.123,\"longitude\":12.123,\"metro_code\":0}\n"}
  end
end
