module HowTosHelper
  def fields_for_step(step, &block)
    prefix = step.new_record? ? 'new' : 'existing'
    fields_for("how_to[#{prefix}_step_attributes][]", step, &block)
  end

  def add_step_link(step_label)
    link_to_function "Add new <span class='step-title-label'>#{step_label}</span>" do |page|
      page.insert_html :top, :after_steps, :partial => 'step', :object => HowToStep.new
      page << "resetStepLabels();"
      page << "resetStepNumbers();"
    end
  end
end