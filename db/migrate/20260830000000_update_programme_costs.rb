class UpdateProgrammeCosts < ActiveRecord::Migration[7.0]
  OLD_COSTS = {
    "LanghanaM" => "77,000/-",
    "ShaktI" => "65,000/-",
    "ShamanaM" => "36,000/- or Rs. 72,000/-",
    "ShantaM" => "60,500/-",
    "ShodhanaM" => "1,15,000/-",
    "SwaasthyaM" => "49,500/-",
    "VarnyaM" => "49,000/-",
    "VishraM" => "16,280 or Rs. 27,000"
  }.freeze

  NEW_COSTS = {
    "LanghanaM" => "82,500/-",
    "ShaktI" => "65,000/-",
    "ShamanaM" => "41,000/- or Rs. 82,000/-",
    "ShantaM" => "65,000/-",
    "ShodhanaM" => "1,20,000/-",
    "SwaasthyaM" => "55,000/-",
    "VarnyaM" => "55,000/-",
    "VishraM" => "18,000 or Rs. 30,000"
  }.freeze

  class MigrationPackage < ActiveRecord::Base
    self.table_name = "packages"
  end

  def up
    update_costs(NEW_COSTS)
  end

  def down
    update_costs(OLD_COSTS)
  end

  private

  def update_costs(costs)
    costs.each do |name, cost|
      MigrationPackage.where(name: name).update_all(cost: cost, updated_at: Time.current)
    end
  end
end
