class User < ApplicationRecord
  has_many :sender_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :recipient_messages, class_name: 'Message', foreign_key: 'recipient_id'
end
