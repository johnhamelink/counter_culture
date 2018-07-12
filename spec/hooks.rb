require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'models/company'
require 'models/soft_delete_discard'
require 'models/soft_delete_paranoia'
require 'models/soft_delete_paranoia_with_custom_column'

require 'database_cleaner'
DatabaseCleaner.strategy = :deletion

describe "CounterCulture" do
  before(:each) do
    DatabaseCleaner.clean
  end

  describe 'Hooks' do

    context 'Paranoia' do
      it 'Filters out soft-deleted records when counting' do
        a = SoftDeleteParanoia.create(company_id: 1)
        b = SoftDeleteParanoia.create(company_id: 2)
        c = SoftDeleteParanoia.create(company_id: 3)

        a.destroy
        c.destroy

        SoftDeleteParanoia.counter_culture_fix_counts
        expect SoftDeleteParanoia.count(1)
        expect(a.deleted_at).to_not be_nil
        expect(c.deleted_at).to_not be_nil
        expect(b.deleted_at).to be_nil
      end

      it 'Handles custom columns' do
        a = SoftDeleteParanoiaWithCustomColumn.create(company_id: 1)
        b = SoftDeleteParanoiaWithCustomColumn.create(company_id: 2)
        c = SoftDeleteParanoiaWithCustomColumn.create(company_id: 3)

        a.destroy
        c.destroy

        SoftDeleteParanoiaWithCustomColumn.counter_culture_fix_counts
        expect SoftDeleteParanoiaWithCustomColumn.count(1)
        expect(a.lorem).to_not be_nil
        expect(c.lorem).to_not be_nil
        expect(b.lorem).to be_nil
      end
    end

    context 'Discard' do
      it 'Can run hooks correctly' do
        dummy = SoftDeleteDiscard.create(company_id: 1)
        expect(dummy).to receive(:_update_counts_after_destroy).once
        expect(dummy).to receive(:_update_counts_after_create).once
        dummy.discard
        dummy.undiscard
      end

      it 'Filters out soft-deleted records when counting' do
        a = SoftDeleteDiscard.create(company_id: 1)
        b = SoftDeleteDiscard.create(company_id: 2)
        c = SoftDeleteDiscard.create(company_id: 3)

        a.discard
        c.discard

        SoftDeleteDiscard.counter_culture_fix_counts
        expect SoftDeleteDiscard.count(1)

      end
    end
  end
end
