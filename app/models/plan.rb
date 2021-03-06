# This model is not meant to sync with Stripe -
# just to hold the unique stripe_id as a convenience for retrieval.
class Plan < ApplicationRecord
  include CurrencyHelper
  validates :name, presence: true
  validates :amount, presence: true
  has_many :users
  before_create :create_plan_on_stripe

  scope :active, -> { where(active: true) }

  include ActionView::Helpers::NumberHelper

  def cost
    formatted_amount(amount, currency)
  end

  private

  def create_plan_on_stripe
    # stripe_id is populated by factory in tests
    CreatePlanService.new(self).call unless Rails.env.test?
  end
end
