module Repeatable
  extend ActiveSupport::Concern

  included do
    DAYS = %i(sun mon tue wed thu fri sat)

    bitmask :repeats_at, as: DAYS, null: false, default: DAYS do
      def to_days_of_week
        days = []
        days << 0 if include? :sun
        days << 1 if include? :mon
        days << 2 if include? :tue
        days << 3 if include? :wed
        days << 4 if include? :thu
        days << 5 if include? :fri
        days << 6 if include? :sat
        days
      end

      def to_s
        I18n.t("date.abbr_day_names").values_at(*to_days_of_week).join("/")
      end
    end

    validates :repeats_at, presence: true, numericality: { greater_than: 0 }
  end
end
