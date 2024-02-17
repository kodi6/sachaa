alias NimbleCSV.RFC4180, as: CSV
alias SacchaSur.Repo
alias SacchaSur.State

:code.priv_dir(:saccha_sur)
|> Path.join("data/final_states.csv")
|> File.read!()
|> CSV.parse_string()
|> Enum.each(fn([id, name, country_id]) ->

  id = String.trim(id)
  name = String.trim(name)
  country_id = String.trim(country_id)





   %State{
    state_id: id,
    name: name,
    country_id: country_id,
   } |> Repo.insert!


end)
