# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Minenum::Enum::ClassBuilder do
  describe 'Enum object' do
    let(:enum_class) { described_class.build(foo: 0, bar: 1) }
    let(:enum_object) do
      object = enum_class.new
      object.value = value
      object
    end

    describe '.values' do
      subject(:values) { enum_class.values }

      it { expect(values).to eq(foo: 0, bar: 1) }
    end

    describe '#name' do
      subject { enum_object.name }

      [
        [0, :foo],
        [1, :bar],
        [2, nil]
      ].each do |value, expected|
        context "when the value is #{value.inspect}" do
          let(:value) { value }

          it { is_expected.to eq(expected) }
        end
      end
    end

    describe '#foo?' do
      subject { enum_object.foo? }

      [
        [0, true],
        [1, false],
        [2, false]
      ].each do |value, expected|
        context "when the value is #{value.inspect}" do
          let(:value) { value }

          it { is_expected.to eq(expected) }
        end
      end
    end

    describe '#bar?' do
      subject { enum_object.bar? }

      [
        [0, false],
        [1, true],
        [2, false]
      ].each do |value, expected|
        context "when the value is #{value.inspect}" do
          let(:value) { value }

          it { is_expected.to eq(expected) }
        end
      end
    end

    describe '#foo!' do
      subject { enum_object.value }

      let(:value) { nil }

      before { enum_object.foo! }

      it { is_expected.to eq(0) }
    end

    describe '#bar!' do
      subject { enum_object.value }

      let(:value) { nil }

      before { enum_object.bar! }

      it { is_expected.to eq(1) }
    end
  end
end
