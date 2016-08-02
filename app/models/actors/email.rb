module Actors
  class Email < Actor
    store_accessor :config, :receipient, :credentials_id, :credentials_pw

    def to_nodes(payload, x = 100, y = 100)
      actor_id = SecureRandom.uuid
      email_id = SecureRandom.uuid

      return actor_id, [
        {
          id: actor_id,
          x: x += 200,
          y: y,
          type: "change",
          rules: [
            {
              t: "set",
              p: "payload",
              pt: "msg",
              to: payload["subject"],
              tot: "str"
            },
            {
              t: "set",
              p: "topic",
              pt: "msg",
              to: payload["body"],
              tot: "str"
            },
            {
              t: "set",
              p: "to",
              pt: "msg",
              to: receipient,
              tot: "str"
            }
          ],
          action: "",
          property: "",
          from: "",
          to: "",
          reg: false,
          wires: [[email_id]]
        },
        {
          id: email_id,
          x: x += 200,
          y: y,
          type: "e-mail",
          server: "smtp.gmail.com",
          port: "465",
          name: "",
          dname: "",
          credentials: {
            userid: credentials_id,
            password: credentials_pw
          },
          wires: []
        }
      ]
    end
  end
end
