defmodule CdpPro.Contract do
  alias ExW3.Contract

  def get_debt(cdp_id) do
    tab = Contract.call(:Tub, :tab, [<<cdp_id :: size(256)>>])
    case tab do
      {:ok, 0} -> {:error, :cdp_id_not_found}
      {:ok, debt} -> {:ok, debt}
    end
  end

  def get_peth_price() do
    tag = Contract.call(:Tub, :tag)
    case tag do
      {:ok, 0} -> {:error, :peth_price_not_available}
      {:ok, price} -> {:ok, price}
    end
  end

  def get_peth_collateral(cdp_id) do
    ink = Contract.call(:Tub, :ink, [<<cdp_id :: size(256)>>])
    case ink do
      {:ok, 0} -> {:error, :cdp_id_not_found}
      {:ok, collateral} -> {:ok, collateral}
    end
  end

  def get_collateralization_ratio(cdp_id) do
    with {:ok, debt} <- get_debt(cdp_id),
         {:ok, peth_price} <- get_peth_price(),
         {:ok, peth_collateral} <- get_peth_collateral(cdp_id) do
      floor(((peth_collateral * peth_price) / debt ) / 1.0e25)
    end
  end
end
