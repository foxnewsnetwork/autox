defmodule Dummy.ShopControllerTest do
  use Dummy.ConnCase
  alias Dummy.SeedSupport
  test "simple post create", %{conn: conn} do
    params = %{
      "data" => %{
        "type" => "shops",
        "attributes" => SeedSupport.shop_attributes
      }
    }
    conn = conn
    |> post("/api/shops", params)
    assert %{"data" => data} = json_response(conn, 201)
    assert %{"id" => _, "type" => "shops", "attributes" => attributes} = data
    assert %{"name" => "test shop", "location" => "testland", "inserted_at" => _, "updated_at" => _} = attributes
  end

  test "relational post create", %{conn: conn} do
    %{id: id} = SeedSupport.build_owner
    params = %{
      "data" => %{
        "type" => "shops",
        "attributes" => SeedSupport.shop_attributes,
        "relationships" => %{
          "owner" => %{
            "data" => %{
              "type" => "owners",
              "id" => id
            }
          }
        }
      }
    }
    conn = conn |> post("/api/shops", params)
    assert %{"data" => data} = json_response(conn, 201)
    assert %{
      "id" => _, 
      "type" => "shops", 
      "attributes" => _, 
      "relationships" => relationships, 
      "links" => %{"self" => _}
    } = data
    assert %{
      "owner" => owner, 
      "tacos" => tacos,
      "salsas" => salsas
    } = relationships
    assert %{
      "links" => %{"self" => _},
      "data" => %{ "id" => ^id, "type" => "owners"}
    } = owner
    assert %{"links" => %{"self" => _}} = tacos
    refute tacos["data"] == []
    assert %{"links" => %{"self" => _}} = salsas
    refute salsas["data"] == []
  end
end