class UpdateTeamMemberNameToNikhilaChinthalapudi < ActiveRecord::Migration[7.0]
  OLD_NAMES = ["Dr. Divya P.S, BAMS", "Dr. Divya"].freeze
  NEW_NAME = "Dr. Nikhila Chinthalapudi"

  class MigrationTeamMember < ActiveRecord::Base
    self.table_name = "team_members"
  end

  def up
    MigrationTeamMember.where(name: OLD_NAMES).update_all(name: NEW_NAME, updated_at: Time.current)
  end

  def down
    MigrationTeamMember.where(name: NEW_NAME).update_all(name: OLD_NAMES.first, updated_at: Time.current)
  end
end
