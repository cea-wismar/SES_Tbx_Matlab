within ;
model Demo1_1 "demo model with mode=1"

  demo2Lib.Sine Sine1(Amplitude=0.1, Frequency=1.0472) annotation (Placement(transformation(extent={{-84,66},{-64,86}})));
  demo2Lib.Sine Sine2(Amplitude=2, Frequency=1) annotation (Placement(transformation(extent={{-84,28},{-64,48}})));
  demo2Lib.Sine Sine3(Amplitude=0.3, Frequency=0.5236) annotation (Placement(transformation(extent={{-82,-12},{-62,8}})));
  demo2Lib.TransferFcn transferFcn(Numerator={1,0.7}, Denominator={1,0.09,0.5}) annotation (Placement(transformation(extent={{-46,28},{-26,48}})));
  demo2Lib.Add3 add3_1 annotation (Placement(transformation(extent={{4,28},{24,48}})));
  demo2Lib.Out out annotation (Placement(transformation(extent={{38,28},{58,48}})));
equation
  connect(Sine2.O1, transferFcn.I1) annotation (Line(points={{-63,38},{-48,38},{-48,38}}, color={0,0,127}));
  connect(transferFcn.O1, add3_1.I2) annotation (Line(points={{-25,38},{-12,38},{2,38}}, color={0,0,127}));
  connect(Sine1.O1, add3_1.I1) annotation (Line(points={{-63,76},{-12,76},{-12,
          46},{2,46}}, color={0,0,127}));
  connect(Sine3.O1, add3_1.I3) annotation (Line(points={{-61,-2},{-12,-2},{-12,
          30},{2,30}}, color={0,0,127}));
  connect(add3_1.O1, out.I1) annotation (Line(points={{25,38},{30.5,38},{36,38}}, color={0,0,127}));
  annotation (uses(Modelica(version="3.2.1")), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=10),
    __Dymola_experimentSetupOutput);
end Demo1_1;
