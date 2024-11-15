import {
  AppShell,
  Container,
  MantineProvider,
  ScrollArea,
} from "@mantine/core";
import {
  BarElement,
  CategoryScale,
  Chart,
  Colors,
  LinearScale,
  LineElement,
  PointElement,
  Tooltip,
} from "chart.js";
import { Bar, Line } from "react-chartjs-2";
import "./App.css";
import MONTHLY from "./assets/monthly.json";

Chart.register(
  BarElement,
  LineElement,
  PointElement,
  CategoryScale,
  LinearScale,
  Colors,
  Tooltip
);

function App() {
  const inflowOutflowData = {
    labels: ["Amount", "Month"],
    datasets: [
      {
        label: "Inflow",
        backgroundColor: "green",
        data: MONTHLY.map((d) => ({
          x: d.date,
          y: d.inflow,
        })),
      },
      {
        label: "Outflow",
        backgroundColor: "red",
        data: MONTHLY.map((d) => ({
          x: d.date,
          y: d.outflow,
        })),
      },
    ],
  };

  const totalValueData = {
    datasets: [
      {
        label: "Total",
        backgroundColor: "blue",
        data: MONTHLY.map((d) => ({
          x: d.date,
          y: d.total,
        })),
      },
    ],
  };

  const width = MONTHLY.length * 50;
  const height = 1000;

  console.log(inflowOutflowData.datasets[0].data[0]);
  return (
    <MantineProvider defaultColorScheme="light">
      <AppShell>
        <AppShell.Navbar p="md">
          {/* <Stack>{navLinks}</Stack> */}
        </AppShell.Navbar>
        <AppShell.Main>
          <ScrollArea
            style={{
              // width: "100%",
              height: "100%",
            }}
          >
            <Container
              style={{
                position: "relative",
                width: width,
                height: height,
              }}
            >
              <Bar
                data={inflowOutflowData}
                options={{
                  responsive: true,
                  animation: false,
                  maintainAspectRatio: false,
                }}
              />
            </Container>
            <Container
              style={{
                position: "relative",
                width: width,
                height: height,
              }}
            >
              <Line
                data={totalValueData}
                options={{
                  responsive: true,
                  animation: false,
                  maintainAspectRatio: false,
                }}
              />
            </Container>
            {/* <Outlet /> */}
          </ScrollArea>
        </AppShell.Main>
      </AppShell>
    </MantineProvider>
  );
}

export default App;
