# frozen_string_literal: true

require 'spec_helper'

describe DDSL::Shell do
  subject { DDSL::Shell.new }

  describe '#call!' do
    context 'when exit status of the program is 0' do
      it 'doesn\'t raise an error' do
        expect do
          subject.call!(%w[exit 0])
        end.not_to raise_error
      end
    end

    context 'when exit status of the program is not 0' do
      it 'raise a DDSL::Shell::ExitStatusError' do
        expect do
          subject.call!(%w[exit 1])
        end.to raise_error(DDSL::Shell::ExitStatusError)
      end
    end
  end
end
