require "rails_helper"

describe SDG::Target do
  it "is valid" do
    expect(build(:sdg_target, goal_id: 1)).to be_valid
  end

  it "is not valid without a code" do
    expect(build(:sdg_target, code: nil, goal_id: 1)).not_to be_valid
  end

  it "is not valid without a goal" do
    target = build(:sdg_target, goal_id: nil)

    expect(target).not_to be_valid
  end

  it "is not valid when code is duplicated for the same parent goal" do
    create(:sdg_target, code: "1.1", goal_id: 1)

    expect(build(:sdg_target, code: "1.1", goal_id: 1)).not_to be_valid
  end

  it "translates description" do
    target = create(:sdg_target, code: "1.1", goal_id: 1)

    expect(target.title).to eq "1.1 By 2030, eradicate extreme poverty for all people everywhere, " \
                                     "currently measured as people living on less than $1.25 a day"

    I18n.with_locale(:es) do
      expect(target.title).to eq "1.1 Para 2030, erradicar la pobreza extrema para todas las " \
                                       "personas en el mundo, actualmente medida por un ingreso por " \
                                       "persona inferior a 1,25 dólares al día."
    end

    target = create(:sdg_target, code: "17.11", goal_id: 17)

    expect(target.title).to eq "17.11 Significantly increase the exports of developing countries, " \
                                     "in particular with a view to doubling the least developed " \
                                     "countries’ share of global exports by 2020."

    I18n.with_locale(:es) do
      expect(target.title).to eq "17.11 Aumentar significativamente las exportaciones de los países " \
                                       "en desarrollo, en particular con miras a duplicar la " \
                                       "participación de los países menos adelantados en las " \
                                       "exportaciones mundiales de aquí a 2020."
    end
  end
end
