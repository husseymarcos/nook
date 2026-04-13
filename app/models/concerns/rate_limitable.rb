module RateLimitable
  extend ActiveSupport::Concern

  FREE_SEARCHES_PER_MONTH = 10

  def can_search?
    return true if premium?

    reset_search_count_if_new_month
    searches_this_month < FREE_SEARCHES_PER_MONTH
  end

  def increment_search_count!
    increment!(:searches_this_month)
  end

  private

    def reset_search_count_if_new_month
      if last_search_reset_at.nil? || last_search_reset_at.month != Time.current.month
        update!(searches_this_month: 0, last_search_reset_at: Time.current)
      end
    end
end
