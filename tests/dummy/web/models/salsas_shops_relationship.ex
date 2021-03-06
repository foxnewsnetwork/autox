defmodule Dummy.SalsasShopsRelationship do
  use Dummy.Web, :model

  schema "salsas_shops" do
    field :authorization_key, :string
    belongs_to :salsa, Dummy.Salsa
    belongs_to :shop, Dummy.Shop
    timestamps
  end

  @create_fields ~w(salsa_id shop_id authorization_key)
  @update_fields @create_fields
  @optional_fields ~w()

  def create_changeset(model, params\\:empty) do
    model
    |> cast(params, @create_fields, @optional_fields)
  end

  def update_changeset(model, params\\:empty) do 
    create_changeset(model, params)
  end
end