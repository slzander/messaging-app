require 'rails_helper'

RSpec.describe MessageFilterService, type: :service do
  describe 'filter' do
    let(:frank_user) { User.create(name: Faker::Name.first_name, email: Faker::Internet.email) }
    let(:bob_user) { User.create(name: Faker::Name.first_name, email: Faker::Internet.email) }
    let(:claire_user) { User.create(name: Faker::Name.first_name, email: Faker::Internet.email) }
    let(:message_from_frank_to_bob1) { Message.create(sender: frank_user, recipient: bob_user, body: Faker::Lorem.sentence) }
    let(:message_from_frank_to_bob2) { Message.create(sender: frank_user, recipient: bob_user, body: Faker::Lorem.sentence) }
    let(:message_from_frank_to_bob3) { Message.create(sender: frank_user, recipient: bob_user, body: Faker::Lorem.sentence) }
    let!(:message_from_bob_to_frank1) { Message.create(sender: bob_user, recipient: frank_user, body: Faker::Lorem.sentence) }
    let!(:message_from_clair_to_frank1) { Message.create(sender: claire_user, recipient: frank_user, body: Faker::Lorem.sentence) }

    context 'when there is no sender_id indicated in message params' do
      it 'should only include all messages belonging to the user, sorted from newest to oldest' do
        message_from_frank_to_bob3.created_at = 10.days.ago
        message_from_frank_to_bob3.save
        message_from_frank_to_bob1.created_at = 5.days.ago
        message_from_frank_to_bob1.save
        message_from_clair_to_frank1.created_at = 5.days.ago
        message_from_clair_to_frank1.save

        frank_messages = MessageFilterService.new(frank_user, {}).filter
        bob_messages = MessageFilterService.new(bob_user, {}).filter

        expect(bob_messages).to eq([message_from_frank_to_bob2, message_from_frank_to_bob1, message_from_frank_to_bob3])
        expect(frank_messages).to eq([message_from_bob_to_frank1, message_from_clair_to_frank1])
      end
    end

    context 'when there is a sender_id indicated in message params' do
      let(:message_params) { { sender_id: claire_user.id } }
      it 'should only include only messages from the sender belonging to that user' do
        frank_messages = MessageFilterService.new(frank_user, message_params).filter

        expect(frank_messages).to eq([message_from_clair_to_frank1])
      end
    end
        
    context 'when there are records more than 30 days old' do
      let(:message_from_bob_to_frank2) { Message.create(sender: bob_user, recipient: frank_user, body: Faker::Lorem.sentence) }
      let(:message_from_bob_to_frank3) { Message.create(sender: bob_user, recipient: frank_user, body: Faker::Lorem.sentence) }

      it 'should limit records to the last 30 days' do
        message_from_bob_to_frank2.created_at = 29.days.ago
        message_from_bob_to_frank2.save
        message_from_bob_to_frank3.created_at = 31.days.ago
        message_from_bob_to_frank3.save

        frank_messages = MessageFilterService.new(frank_user, {}).filter

        expect(frank_messages).to match_array([message_from_bob_to_frank1, message_from_bob_to_frank2, message_from_clair_to_frank1])
      end
    end

    context 'when there are more than 100 records' do
      it 'should limit to 100 records' do
        105.times { Message.create(sender: bob_user, recipient: frank_user, body: Faker::Lorem.sentence) }
        frank_messages = MessageFilterService.new(frank_user, {}).filter

        expect(frank_messages.count).to eq(100)
      end
    end
  end
end