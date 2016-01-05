defmodule Autox.EchoRepo do
  @moduledoc """
  Echo repos don't hit the database
  """
  def insert!(cs) do
    case cs |> insert do
      {:ok, model} -> cs
      {:error, cs} -> raise cs
    end
  end

  def preload(model, _), do: model

  def insert(%{valid?: false}=changeset), do: {:error, changeset}
  def insert(%{model: model, changes: changes}) do
    model = model 
    |> Map.merge(changes)
    |> Map.put(:id, calculate_id(changes))
    {:ok, model}
  end

  def update(%{valid?: false}=cs), do: {:error, cs}
  def update(%{model: model, changes: changes}) do
    model = model 
    |> Map.merge(changes) 

    {:ok, model}
  end

  def calculate_id(changes) do
    changes
    |> Poison.encode
    |> case do
      {:ok, x} -> x
      {:error, _} -> :os.timestamp |> Tuple.to_list |> Enum.join("-")
    end
    |> Base.encode64
  end

  def calculate_params(id) do
    use Pipe
    pipe_with &ok?/2, 
      Base.decode64(id) |> Poison.decode
  end

  defp ok?({:ok, x}, f), do: f.(x)
  defp ok?(whatever, _), do: whatever

  def get(class, id) do
    use Pipe
    result = pipe_with &ok?/2,
      calculate_params(id) |> find(class, id)

    case result do
      {:ok, model} -> model
      nil -> nil
    end
  end
  def one(class, id), do: get(class, id)

  def all(_), do: []

  defp find(params, class, id) do 
    class |> struct(id: id) |> class.create_changeset(params) |> update
  end

  def delete(model), do: {:ok, model}  
end