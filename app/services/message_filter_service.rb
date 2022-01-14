class MessageFilterService
  def initialize(user)
    @user = user
  end

  def filter
    user_messages
  end

  private

  def user_messages
    messages = Message.where(sender_id: @user.id)
    filter_within_last_month(messages)
  end

  def filter_within_last_month(messages)
    filtered_messages = messages.where('created_at > ?', 30.days.ago)
    filter_by_count_limit(filtered_messages)
  end

  def filter_by_count_limit(messages)
    filtered_messages = messages.limit(100)
    sort(filtered_messages)
  end

  def sort(messages)
    messages.order(created_at: :desc)
  end
end