class SetPrimaryKey < ActiveRecord::Migration
  def change
    execute 'ALTER TABLE engravings ADD PRIMARY KEY (id);'
  end
end
