within ;
package demo2Lib "Components for demo2"
  block Sine "Generate sine signal"
    parameter Real Amplitude=1 "Amplitude of sine wave";
    parameter Modelica.SIunits.Frequency Frequency(start=1)
      "Frequency of sine wave";
    parameter Modelica.SIunits.Angle phase=0 "Phase of sine wave";
    parameter Real offset=0 "Offset of output signal";
    parameter Modelica.SIunits.Time startTime=0
      "Output = offset for time < startTime";
    Modelica.Blocks.Interfaces.RealOutput O1
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  protected
    constant Real pi=Modelica.Constants.pi;
  equation
    O1 = offset + (if time < startTime then 0 else
       Amplitude*Modelica.Math.sin(Frequency*(time - startTime) + phase));
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
          Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
          Polygon(
            points={{-80,90},{-88,68},{-72,68},{-80,90}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,
                74.6},{-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,
                59.4},{-14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,
                -64.2},{29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},
                {57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}}, color={0,0,0}, smooth = Smooth.Bezier),
          Text(
            extent={{-147,-152},{153,-112}},
            lineColor={0,0,0},
            textString="f=%Frequency"),
          Rectangle(extent={{-100,100},{100,-102}}, lineColor={28,108,200})}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Line(points={{-80,-90},{-80,84}}, color={95,95,95}),
          Polygon(
            points={{-80,97},{-84,81},{-76,81},{-80,97}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(points={{-99,-40},{85,-40}}, color={95,95,95}),
          Polygon(
            points={{97,-40},{81,-36},{81,-45},{97,-40}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-41,-2},{-31.6,34.2},{-26.1,53.1},{-21.3,66.4},{-17.1,74.6},
                {-12.9,79.1},{-8.64,79.8},{-4.42,76.6},{-0.201,69.7},{4.02,59.4},
                {8.84,44.1},{14.9,21.2},{27.5,-30.8},{33,-50.2},{37.8,-64.2},{
                42,-73.1},{46.2,-78.4},{50.5,-80},{54.7,-77.6},{58.9,-71.5},{
                63.1,-61.9},{67.9,-47.2},{74,-24.8},{80,0}},
            color={0,0,255},
            thickness=0.5,
            smooth=Smooth.Bezier),
          Line(
            points={{-41,-2},{-80,-2}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{-87,12},{-40,0}},
            lineColor={0,0,0},
            textString="offset"),
          Line(points={{-41,-2},{-41,-40}}, color={95,95,95}),
          Text(
            extent={{-60,-43},{-14,-54}},
            lineColor={0,0,0},
            textString="startTime"),
          Text(
            extent={{75,-47},{100,-60}},
            lineColor={0,0,0},
            textString="time"),
          Text(
            extent={{-80,99},{-40,82}},
            lineColor={0,0,0},
            textString="y"),
          Line(points={{-9,80},{43,80}}, color={95,95,95}),
          Line(points={{-41,-2},{50,-2}}, color={95,95,95}),
          Polygon(
            points={{33,80},{30,67},{36,67},{33,80}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{37,57},{83,39}},
            lineColor={0,0,0},
            textString="Amplitude"),
          Polygon(
            points={{33,-2},{30,11},{36,11},{33,-2},{33,-2}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(points={{33,80},{33,-2}}, color={95,95,95})}));
  end Sine;

  block Add3 "Output the sum of the three inputs"
    extends Modelica.Blocks.Icons.Block;

    parameter Real k1=+1 "Gain of upper input";
    parameter Real k2=+1 "Gain of middle input";
    parameter Real k3=+1 "Gain of lower input";
    Modelica.Blocks.Interfaces.RealInput I1 "Connector 1 of Real input signals"
                                         annotation (Placement(transformation(
            extent={{-140,60},{-100,100}}, rotation=0)));
     Modelica.Blocks.Interfaces.RealInput I2
      "Connector 2 of Real input signals" annotation (Placement(transformation(
            extent={{-140,-20},{-100,20}}, rotation=0)));
     Modelica.Blocks.Interfaces.RealInput I3
      "Connector 3 of Real input signals" annotation (Placement(transformation(
            extent={{-140,-100},{-100,-60}}, rotation=0)));
     Modelica.Blocks.Interfaces.RealOutput O1
      "Connector of Real output signals" annotation (Placement(transformation(
            extent={{100,-10},{120,10}}, rotation=0)));

  equation
    O1 = k1*I1 + k2*I2 + k3*I3;
    annotation (
          Documentation(info="<html>
<p>
This blocks computes output <b>y</b> as <i>sum</i> of the
three input signals <b>u1</b>, <b>u2</b> and <b>u3</b>:
</p>
<pre>
    <b>y</b> = k1*<b>u1</b> + k2*<b>u2</b> + k3*<b>u3</b>;
</pre>
<p>
Example:
</p>
<pre>
     parameter:   k1= +2, k2= -3, k3=1;

  results in the following equations:

     y = 2 * u1 - 3 * u2 + u3;
</pre>

</html>"),       Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Text(
            extent={{-100,50},{5,90}},
            lineColor={0,0,0},
            textString="%k1"),
          Text(
            extent={{-100,-20},{5,20}},
            lineColor={0,0,0},
            textString="%k2"),
          Text(
            extent={{-100,-50},{5,-90}},
            lineColor={0,0,0},
            textString="%k3"),
          Text(
            extent={{2,36},{100,-44}},
            lineColor={0,0,0},
            textString="+")}),
          Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,50},{5,90}},
            lineColor={0,0,0},
            textString="k1"),
          Text(
            extent={{-100,-20},{5,20}},
            lineColor={0,0,0},
            textString="k2"),
          Text(
            extent={{-100,-50},{5,-90}},
            lineColor={0,0,0},
            textString="k3"),
          Text(
            extent={{2,46},{100,-34}},
            lineColor={0,0,0},
            textString="+")}));
  end Add3;

  block TransferFcn "Linear transfer function"
    import Modelica.Blocks.Types.Init;

    parameter Real Numerator[:]={1}
      "Numerator coefficients of transfer function (e.g., 2*s+3 is specified as {2,3})";
    parameter Real Denominator[:]={1}
      "Denominator coefficients of transfer function (e.g., 5*s+6 is specified as {5,6})";
    parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit
      "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
                                       annotation(Evaluate=true, Dialog(group=
            "Initialization"));
    parameter Real x_start[size(Denominator, 1) - 1]=zeros(nx)
      "Initial or guess values of states"
      annotation (Dialog(group="Initialization"));
    parameter Real y_start=0
      "Initial value of output (derivatives of y are zero upto nx-1-th derivative)"
      annotation(Dialog(enable=initType == Init.InitialOutput, group=
            "Initialization"));
    output Real x[size(Denominator, 1) - 1](start=x_start)
      "State of transfer function from controller canonical form";
    Modelica.Blocks.Interfaces.RealInput I1 "Connector of Real input signal" annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    Modelica.Blocks.Interfaces.RealOutput O1 "Connector of Real output signal" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
  protected
    parameter Integer na=size(Denominator, 1)
      "Size of Denominator of transfer function.";
    parameter Integer nb=size(Numerator, 1)
      "Size of Numerator of transfer function.";
    parameter Integer nx=size(Denominator, 1) - 1;
    parameter Real bb[:] = vector([zeros(max(0,na-nb),1);Numerator]);
    parameter Real d = bb[1]/Denominator[1];
    parameter Real a_end = if Denominator[end] > 100*Modelica.Constants.eps*sqrt(Denominator*Denominator) then Denominator[end] else 1.0;
    Real x_scaled[size(x,1)] "Scaled vector x";

  initial equation
    if initType == Init.SteadyState then
      der(x_scaled) = zeros(nx);
    elseif initType == Init.InitialState then
      x_scaled = x_start*a_end;
    elseif initType == Init.InitialOutput then
      O1 = y_start;
      der(x_scaled[2:nx]) = zeros(nx-1);
    end if;
  equation
    assert(size(Numerator,1) <= size(Denominator,1), "Transfer function is not proper");
    if nx == 0 then
       O1 = d*I1;
    else
       der(x_scaled[1])    = (-Denominator[2:na]*x_scaled + a_end*I1)/Denominator[1];
       der(x_scaled[2:nx]) = x_scaled[1:nx-1];
       O1 = ((bb[2:na] - d*Denominator[2:na])*x_scaled)/a_end + d*I1;
       x = x_scaled/a_end;
    end if;
    annotation (
      Icon(
          coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            initialScale=0.1),
            graphics={
          Line(visible=true,
            points={{-80.0,0.0},{80.0,0.0}},
            color={0,0,127}),
        Text(visible=true,
          lineColor={0,0,127},
          extent={{-90.0,10.0},{90.0,90.0}},
          textString="b(s)"),
        Text(visible=true,
          lineColor={0,0,127},
          extent={{-90.0,-90.0},{90.0,-10.0}},
          textString="a(s)"),
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0})}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Line(points={{40,0},{-40,0}}, color={0,0,0}),
          Text(
            extent={{-55,55},{55,5}},
            lineColor={0,0,0},
            textString="b(s)"),
          Text(
            extent={{-55,-5},{55,-55}},
            lineColor={0,0,0},
            textString="a(s)"),
          Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
          Line(points={{-100,0},{-60,0}}, color={0,0,255}),
          Line(points={{60,0},{100,0}}, color={0,0,255})}));
  end TransferFcn;

  block LookupTable1D
    "Table look-up in one dimension (matrix/file) with one input and 1 output"
    parameter Real BreakpointsForDimension1[:] = {1,2,3} "x values";
    parameter Real Table[:] = {1,4,9} "y values";
    Modelica.Blocks.Interfaces.RealInput I1 "Connector of Real input signal" annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
    Modelica.Blocks.Interfaces.RealOutput O1 "Connector of Real output signal" annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
  protected
    Modelica.Blocks.Types.ExternalCombiTable1D tableID=
        Modelica.Blocks.Types.ExternalCombiTable1D(
          "NoName", "NoName", transpose({BreakpointsForDimension1,Table}), {2},
          Modelica.Blocks.Types.Smoothness.LinearSegments)
      "External table object";

    function getTableValue "Interpolate 1-dim. table defined by matrix"
      extends Modelica.Icons.Function;
      input Modelica.Blocks.Types.ExternalCombiTable1D tableID;
      input Integer icol;
      input Real u;
      input Real tableAvailable
        "Dummy input to ensure correct sorting of function calls";
      output Real y;
      external"C" y = ModelicaStandardTables_CombiTable1D_getValue(tableID, icol, u)
        annotation (Library={"ModelicaStandardTables"});
      annotation (derivative(noDerivative=tableAvailable) = getDerTableValue);
    end getTableValue;

    function getDerTableValue
      "Derivative of interpolated 1-dim. table defined by matrix"
      extends Modelica.Icons.Function;
      input Modelica.Blocks.Types.ExternalCombiTable1D tableID;
      input Integer icol;
      input Real u;
      input Real tableAvailable
        "Dummy input to ensure correct sorting of function calls";
      input Real der_u;
      output Real der_y;
      external"C" der_y = ModelicaStandardTables_CombiTable1D_getDerValue(tableID, icol, u, der_u)
        annotation (Library={"ModelicaStandardTables"});
    end getDerTableValue;

  equation
    assert(size(Table, 1) > 0 and size(Table,1) == size(BreakpointsForDimension1,1),
        "data vectors are empty or don't match");
     O1 = getTableValue(tableID, 1, I1, 1);
    annotation (
     Icon(
      coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        initialScale=0.1),
        graphics={
      Rectangle(fillColor={255,215,136},
        fillPattern=FillPattern.Solid,
        extent={{-30,22},{0,42}}),
      Rectangle(fillColor={255,215,136},
        fillPattern=FillPattern.Solid,
        extent={{-30,2},{0,22}}),
      Rectangle(fillColor={255,215,136},
        fillPattern=FillPattern.Solid,
        extent={{-30,-18},{0,2}}),
      Rectangle(fillColor={255,215,136},
        fillPattern=FillPattern.Solid,
        extent={{-30,-38},{0,-18}}),
      Rectangle(
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            extent={{0,22},{30,42}}),
      Rectangle(
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            extent={{0,2},{30,22}}),
      Rectangle(
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            extent={{0,-18},{30,2}}),
      Rectangle(
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            extent={{0,-38},{30,-18}}),
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0})}),
      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics={
          Rectangle(
            extent={{-60,62},{60,-58}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Line(points={{-100,0},{-58,0}}, color={0,0,255}),
          Line(points={{60,0},{100,0}}, color={0,0,255}),
          Text(
            extent={{-100,100},{100,64}},
            textString="1 dimensional linear table interpolation",
            lineColor={0,0,255}),
          Rectangle(
            extent={{-24,40},{2,20}},
            lineColor={0,0,0},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-24,20},{2,0}},
            lineColor={0,0,0},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-24,0},{2,-20}},
            lineColor={0,0,0},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-24,-20},{2,-40}},
            lineColor={0,0,0},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-22,56},{-4,44}},
            textString="u",
            lineColor={0,0,255}),
          Text(
            extent={{4,56},{28,44}},
            lineColor={0,0,255},
            textString="y"),
          Rectangle(
            extent={{2,40},{28,20}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{2,20},{28,0}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{2,0},{28,-20}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{2,-20},{28,-40}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end LookupTable1D;

  block Out "External output"
    extends Modelica.Blocks.Icons.Block;
    parameter Integer Port=1 "dummy, needed in Simulink";
    Modelica.Blocks.Interfaces.RealInput I1  annotation (Placement(transformation(
            extent={{-140,-20},{-100,20}}, rotation=0)));
    Modelica.Blocks.Interfaces.RealOutput O1 annotation (Placement(transformation(
            extent={{100,-10},{120,10}}, rotation=0)));
  equation
    O1 = I1;
    annotation (
          Documentation(info="<html>
<p>
This blocks computes output <b>y</b> as <i>sum</i> of the
three input signals <b>u1</b>, <b>u2</b> and <b>u3</b>:
</p>
<pre>
    <b>y</b> = k1*<b>u1</b> + k2*<b>u2</b> + k3*<b>u3</b>;
</pre>
<p>
Example:
</p>
<pre>
     parameter:   k1= +2, k2= -3, k3=1;

  results in the following equations:

     y = 2 * u1 - 3 * u2 + u3;
</pre>

</html>"),       Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Text(
            extent={{-72,58},{70,-46}},
            lineColor={28,108,200},
            textString="Signal")}),
          Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end Out;
  annotation (uses(Modelica(version="3.2.1")));
end demo2Lib;
