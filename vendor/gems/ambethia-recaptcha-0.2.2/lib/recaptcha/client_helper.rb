module Recaptcha
  module ClientHelper
    # Your public API can be specified in the +options+ hash or preferably
    # the environment variable +RECAPTCHA_PUBLIC_KEY+.
    def recaptcha_tags(options = {})
      # Default options
      key   = options[:public_key] ||= ENV['RECAPTCHA_PUBLIC_KEY']
      error = options[:error] ||= session[:recaptcha_error]
      uri   = options[:ssl] ? RECAPTCHA_API_SECURE_SERVER : RECAPTCHA_API_SERVER
      html  = ""
      if options[:display]
        html << %{<script type="text/javascript">\n}
        html << %{  var RecaptchaOptions = #{options[:display].to_json};\n}
        html << %{</script>\n}
      end
      if options[:ajax]
        html << <<-EOS
          <div id="dynamic_recaptcha"></div>
          <script type="text/javascript">
            var rc_script_tag = document.createElement('script'),
                rc_init_func = function(){Recaptcha.create("#{key}", document.getElementById("dynamic_recaptcha")#{',RecaptchaOptions' if options[:display]});}
            rc_script_tag.src = "#{uri}/js/recaptcha_ajax.js";
            rc_script_tag.type = 'text/javascript';
            rc_script_tag.onload = function(){rc_init_func.call();};
            rc_script_tag.onreadystatechange = function(){
              if (rc_script_tag.readyState == 'loaded' || rc_script_tag.readyState == 'complete') {rc_init_func.call();}
            };
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(rc_script_tag);
          </script>
        EOS
      else
        html << %{<script type="text/javascript" src="#{uri}/challenge?k=#{key}}
        html << %{#{error ? "&error=#{CGI::escape(error)}" : ""}"></script>\n}
        unless options[:noscript] == false
          html << %{<noscript>\n  }
          html << %{<iframe src="#{uri}/noscript?k=#{key}" }
          html << %{height="#{options[:iframe_height] ||= 300}" }
          html << %{width="#{options[:iframe_width]   ||= 500}" }
          html << %{frameborder="0"></iframe><br/>\n  }
          html << %{<textarea name="recaptcha_challenge_field" }
          html << %{rows="#{options[:textarea_rows] ||= 3}" }
          html << %{cols="#{options[:textarea_cols] ||= 40}"></textarea>\n  }
          html << %{<input type="hidden" name="recaptcha_response_field" value="manual_challenge">}
          html << %{</noscript>\n}
        end
      end
      raise RecaptchaError, "No public key specified." unless key
      return html
    end # recaptcha_tags
  end # ClientHelper
end # Recaptcha