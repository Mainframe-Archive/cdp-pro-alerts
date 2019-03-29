defmodule CdpProWeb.ErrorView do
  use CdpProWeb, :view

  def render("400.json", %{changeset: changeset}) do
    %{
      status: "failure",
      errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    }
  end

  def render("400.json", _assigns) do
    %{
      status: "failure",
      errors: "bad request"
    }
  end

  def render("404.html", _assigns) do
    "Not Found"
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
