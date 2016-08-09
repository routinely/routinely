class Group < ActiveRecord::Base
  store_accessor :nodered_config, :mqtt_broker, :twilio_api, :google_api, :rx_subflow, :tx_subflow, :hue_server

  has_many :users, dependent: :destroy
  has_many :routines, dependent: :destroy
  has_many :sensors, dependent: :destroy
  has_many :actors, dependent: :destroy

  has_many :rule_based_routines, dependent: :destroy
  has_many :time_based_routines, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
