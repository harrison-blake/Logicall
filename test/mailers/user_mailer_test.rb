require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "staff_invitation" do
    mail = UserMailer.staff_invitation
    assert_equal "Staff invitation", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
