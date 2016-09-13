require 'highline/import'

namespace :group do |args|
  task setup: :environment do
    name = ask "Group name: "
    group = Group.create(name: name)

    if agree("Add an Email actor? ") { |q| q.default = "y" }
      email_id = ask "Email id: "
      email_pw = ask "Email password: "
      Actors::Email.create(group: group, name: "Email", icon: "icons/actor-email.png", credentials_id: email_id, credentials_pw: email_pw)
    end

    if agree("Add a Ninja Eyes actor? ") { |q| q.default = "y" }
      Actors::Eye.create(group: group, name: "Ninja Eyes", icon: "icons/actor-eye.png")
    end

    if agree("Add Hue actors? ") { |q| q.default = "y" }
      server_id = ask "Hue server id: "
      device_ids = ask("Hue device ids: ", -> (a) { a.split(",") }) { |q| q.default = "1,2,3" }
      device_ids.each do |device_id|
        Actors::Hue.create(group: group, name: "Hue #{device_id}", icon: "icons/actor-hue.png", server_id: server_id, device_id: device_id)
      end
    end

    if agree("Add a SMS actor? ") { |q| q.default = "y" }
      twilio_api = ask "Twilio api: "
      Actors::Sms.create(group: group, name: "Sms", icon: "icons/actor-sms.png", twilio_api: twilio_api)
    end

    if agree("Add a socket actor? ") { |q| q.default = "y" }
      Actors::Socket.create(group: group, name: "Socket", icon: "icons/actor-socket.png")
    end

    if agree("Add a door sensor? ") { |q| q.default = "y" }
      Sensors::Door.create(group: group, kind: :binary, name: "Door", icon: "icons/sensor-door.png")
    end

    if agree("Add a motion sensor? ") { |q| q.default = "y" }
      Sensors::Motion.create(group: group, kind: :binary, name: "Motion", icon: "icons/sensor-motion.png")
    end

    if agree("Add a switch sensor? ") { |q| q.default = "y" }
      Sensors::Switch.create(group: group, kind: :binary, name: "Switch", icon: "icons/sensor-switch.png")
    end

    if agree("Add a humidity sensor? ") { |q| q.default = "y" }
      Sensors::Humidity.create(group: group, kind: :digital, name: "Humidity", icon: "icons/sensor-humidity.png")
    end

    if agree("Add a temperature sensor? ") { |q| q.default = "y" }
      Sensors::Temperature.create(group: group, kind: :digital, name: "Temperature", icon: "icons/sensor-temperature.png")
    end
  end
end
