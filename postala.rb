require "gmail"
require "base64"

Shoes.app width: 400, height: 650 do
  background white

  style Shoes::Stack, margin_bottom: 10
  style Shoes::EditLine, width: 300
  style Shoes::EditBox, width: 300

  @form = flow(margin_left: 50, margin_right: 50) {

    flow {
      @title = title "Bulk Email Sender"
      @title.style align: "center", margin_bottom: 10, margin_top: 10

      @login_form = flow do

        stack do
          caption "Email"
          @email = edit_line
        end

        stack do
          caption "Password"
          @password = edit_line(:secret => true)
        end

        @login_button = button "Login", margin_left: 240 do

          flow do
            # Start Gmail Instance
            @gmail = Gmail.connect(@email.text, @password.text)

            if @gmail.logged_in?
              @login_button.remove()
              @login_form.append do
                @success = caption "✔ Logged In Successfully"
                @success.style margin_top: 5, margin_bottom: 15, align: "right"
              end
            end
          end
        end
      end

      stack do
        caption "Sender Name"
        @sender_name = edit_line
      end

      stack do
        caption "Email Subject"
        @subject_line = edit_line
      end

      stack do
        caption "Email List"
        @emails = edit_box
      end

      stack do
        button "Fetch Emails" do
          @list = @emails.text.scan(/[\w.!#\$%+-]+@[\w-]+(?:\.[\w-]+)+/)
          alert @list.to_s
        end
      end

      stack do
        caption "Image URL"
        @image_url = edit_line
      end

      stack do
        caption "Image Explanation"
        @alt_tag = edit_line
      end

      flow do
        @submit = button "Submit" do
          @list = @emails.text.scan(/[\w.!#\$%+-]+@[\w-]+(?:\.[\w-]+)+/)

          image_tag = '<img src="' + @image_url.text + '" alt="' + @alt_tag.text + '">'
          subject_line = @subject_line.text

          for address in @list
            @gmail.deliver do
              to address
              subject subject_line
              text_part do
                body "Use a modern email client to view this message."
              end
              html_part do
                content_type 'text/html; charset=UTF-8'
                body image_tag
              end
            end
          end

        end
      end

    }


  }

end
