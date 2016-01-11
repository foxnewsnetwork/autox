defmodule Dummy.ErrorView do
  use Dummy.Web, :view

  def render("400.json", %{detail: detail}) do
    %{errors: %{detail: detail}}
  end

  def render("403.json", %{detail: detail}) do
    %{errors: %{detail: detail}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "Page not found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Server internal error"}}
  end

  def render("505.json", _) do
    %{errors: %{detail: "Server internal error"}}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end