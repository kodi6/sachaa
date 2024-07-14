alias NimbleCSV.RFC4180, as: CSV
alias SacchaSur.Repo
alias SacchaSur.City

:code.priv_dir(:saccha_sur)
|> Path.join("data/final_cities.csv")
|> File.read!()
|> CSV.parse_string()
|> Enum.each(fn([id, name, state_id]) ->

  id = String.trim(id)
  name = String.trim(name)
  state_id = String.trim(state_id)



   %City{
    city_id: id,
    name: name,
    state_id: state_id,
   } |> Repo.insert!


end)
