  def help
    Helper.instance
  end

  class Helper
    include Singleton
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::NumberHelper
    include ActionView::Helpers::JavaScriptHelper
    include ApplicationHelper
  end
