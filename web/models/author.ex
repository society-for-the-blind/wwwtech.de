defmodule Wwwtech.Author do
  use Wwwtech.Web, :model

  schema "authors" do
    field :name, :string, null: false
    field :email, :string, null: false
    field :avatar, :string, null: false
    field :encrypted_password, :string, null: false

    has_many :notes, Wwwtech.Note
    has_many :articles, Wwwtech.Article

    timestamps()
  end

  @required_fields [:name, :email, :avatar, :encrypted_password]
  @optional_fields []

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
