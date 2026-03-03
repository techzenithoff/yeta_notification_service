# app/services/message_resolver.rb
class MessageResolver
  class Error < StandardError; end

  MESSAGES = {
    registration: {
      subject: "Confirmation de votre inscription",
      email: { template: "send_otp" }, # utilise ERB
      sms:   "Code d'inscription : %{otp}"
    },

    login: {
      subject: "Connexion sécurisée",
      email: { template: "send_otp" },
      sms:   "Code de connexion : %{otp}"
    },

    account_deletion: {
      subject: "Suppression de compte",
      email: { template: "send_otp" },
      sms:   "Code de suppression : %{otp}"
    },

    polling_confirmation: {
      subject: "Confirmation de votre vote",
      email: { template: "send_otp" },
      sms:   "Votre code de confirmation de vote : %{otp}. Valable pour 5 minutes"
    },

    newsletter: {
      subject: "Votre newsletter",
      email: "<p>Bonjour {{ recipient }}, voici notre newsletter du jour.</p>"
    }
  }.freeze

  def self.resolve!(context, channel:, **payload)
    config = MESSAGES[context.to_sym]
    raise Error, "Context inconnu : #{context}" unless config

    channel_config = config[channel.to_sym]
    raise Error, "Canal non supporté : #{channel}" unless channel_config

    # 🎯 CAS 1 : Template ERB (ActionMailer)
    if channel_config.is_a?(Hash) && channel_config[:template]
      return {
        subject: config[:subject],
        template: channel_config[:template],
        body: nil
      }
    end

    # 🎯 CAS 2 : Format %{key}
    if channel_config.include?("%{")
      body = format(channel_config, payload.symbolize_keys)
    else
      # 🎯 CAS 3 : Template HTML inline (newsletter)
      body = TemplateRenderer.render(channel_config, payload)
    end

    {
      subject: config[:subject],
      body: body,
      template: nil
    }
  end
end