# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  before do 
    load(Rails.root + 'db' + 'seeds.rb')
    @kozaki = email2user('kozaki')
    @tanaka = email2user('tanaka')
    @yamada = email2user('yamada')
    @suzuki = email2user('suzuki')
    @fukaya = email2user('fukaya')

    @received_message = num2message(1)
    @rejected_message = num2message(2)
    @just_send_message = num2message(3)
    @midflow_message = num2message(4)
  end
  context "#reachable_users" do
    it "自分からメッセージが届くユーザーの一覧が得られる"
  end
end
