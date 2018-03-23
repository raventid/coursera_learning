defmodule Bitstringer do
  # Output is a section of one bute(8 bits)
  # in output they are represented as a decimal number
  def separation do
    <<21421531142142141412::256>>

    <<1::1, 1::1, 1::1, 1::1, 1::1, 1::1, 1::1, 1::1>> == <<255>>
  end
end
