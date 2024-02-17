alias NimbleCSV.RFC4180, as: CSV
alias SacchaSur.Repo
alias SacchaSur.Country

:code.priv_dir(:saccha_sur)
|> Path.join("data/final_countries.csv")
|> File.read!()
|> CSV.parse_string()
|> Enum.each(fn([id, name, phone_code]) ->

  id = String.trim(id)
  name = String.trim(name)
  phone_code = String.trim(phone_code)

   %Country{
    country_id: id,
    name: name,
    phone_code: phone_code,
   } |> Repo.insert!

end)
