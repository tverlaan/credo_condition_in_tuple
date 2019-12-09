defmodule CredoConditionInTuple.MixProject do
  use Mix.Project

  def project do
    [
      app: :credo_condition_in_tuple,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:credo, "~> 1.1"}
    ]
  end
end
