class AddSequenceNumToTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :sequence_num, :integer,:null=>false
    update_sequence_num_values
    add_index :teams, [:sequence_num,:company_id], :unique=>true
  end

  def self.down
    remove_index :teams,:column=>[:sequence_num,:company_id]
    remove_column :teams, :sequence_num
  end

  def self.update_sequence_num_values
    Company.all.each do |parent|
      cntr=1
      parent.teams.order("created_at").all.each do |nested|
        nested.sequence_num =cntr
        cntr+=1
        nested.save
      end
    end
  end
end

