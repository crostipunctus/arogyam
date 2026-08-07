class DonationsController < ApplicationController
  CAUSES = [
    {
      key: "general",
      name: "Where It Is Needed Most",
      description: "Give ArogyaM the flexibility to direct support towards its most important current needs.",
      icon: "compass"
    },
    {
      key: "wellness-care",
      name: "Wellness Care Support",
      description: "Help extend thoughtful Ayurvedic and yogic wellness support to people who may need assistance.",
      icon: "heart"
    },
    {
      key: "community-outreach",
      name: "Community Wellness",
      description: "Support wellness awareness, learning, and outreach initiatives for the wider community.",
      icon: "people"
    },
    {
      key: "healing-spaces",
      name: "Healing Spaces & Equipment",
      description: "Contribute towards nurturing ArogyaM's spaces and the equipment used in its wellness work.",
      icon: "flower"
    }
  ].map(&:freeze).freeze

  SUGGESTED_AMOUNTS = [500, 1_000, 2_500, 5_000, 10_000].freeze

  def index
    @causes = CAUSES
    @suggested_amounts = SUGGESTED_AMOUNTS
  end
end
