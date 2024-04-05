# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Minenum::Model do
  let(:figure_class) do
    Class.new do
      include Minenum::Model

      enum :color, { black: 0, red: 1, blue: 2 }
      enum :shape, { triangle: 3, square: 4, pentagon: 5 }
    end
  end

  describe '.color' do
    subject(:color) { figure_class.color }

    it { expect(color.name).to match(/^#<Class:0x\h+>::Color$/) }
    it { expect(color.values).to eq(black: 0, red: 1, blue: 2) }
  end

  describe '.shape' do
    subject(:shape) { figure_class.shape }

    it { expect(shape.name).to match(/^#<Class:0x\h+>::Shape$/) }
    it { expect(shape.values).to eq(triangle: 3, square: 4, pentagon: 5) }
  end

  describe '#color=' do
    subject(:figure) do
      figure = figure_class.new
      figure.color = 1
      figure
    end

    it { expect(figure.color).to be_a(Minenum::Enum::Base) }

    it 'set a specified value' do
      expect(figure.color.red?).to be(true)
    end
  end

  describe '#color' do
    subject { figure_class.new.color }

    it { is_expected.to be_a(Minenum::Enum::Base) }
  end
end
