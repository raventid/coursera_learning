defmodule CachePredictor do
  def update_registry(prediction) do
    Registry.register(prediction)
  end

  def weight(prediction) do
    prediction
  end
end
