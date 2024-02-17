defmodule SacchaSur.CustomerEmail do
  import Swoosh.Email

  def successful_message(record) do
    email =
    new()
    |> from("purnam@auroville.org.in")
    |> to(record.email)
    |> subject("Gratuity request for assesment form")
    |> text_body("""

    <p>Hello [User's Name],</p>

    <p>We are pleased to inform you that access has been granted for the Soul Assessment form. You can now log in and proceed to fill out the form by clicking the button below:</p>

    <a href="#">this special link</a>


    <p>If you have any questions or need further assistance, feel free to contact our support team.</p>
    <p>purnam@auroville.org</p>

    <p>Thank you for your participation!</p>
  </div>

  """)
  SacchaSur.Mailer.deliver(email)
  end


  def failure_message(mail, url) do
    email =
    new()
    |> from("purnam@auroville.org.in")
    |> to(mail)
    |> subject("Access Your Soul Force Assessment Form Now!")
    |> text_body("""

    <div>
    <p>Dear [Recipient's Name],</p>

    <p> Congratulations on taking the first step toward self-discovery! We're excited to share your personalized Soul Force Assessment form.</p>
    <p> Click <a class="text-blue-600" href="#{url}">This special link</a> to access and complete the assessment.Your commitment to understanding your inner self is truly commendable.</p>

    <p>If you have any questions or need further assistance, feel free to contact our support team.</p>
    <p>purnam@auroville.org</p>

    <p>Thank you for your participation!</p>
  </div>

  """)
  SacchaSur.Mailer.deliver(email)
  end
end
