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

  const options = {
    responsive: true,
    // animation: false,
    maintainAspectRatio: true,
  };

  const width = MONTHLY.length * 50;
  const height = 500;
  return (
    <MantineProvider defaultColorScheme="light">
      <AppShell>
        <AppShell.Navbar p="md">
          {/* <Stack>{navLinks}</Stack> */}
        </AppShell.Navbar>
        <AppShell.Main>
          <ScrollArea
            style={{
              width: "100%",
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
              <Bar data={inflowOutflowData} options={options} />
            </Container>
            <Container
              style={{
                position: "relative",
                width: width,
                height: height,
              }}
            >
              <Line data={totalValueData} options={options} />
            </Container>
            {/* <Outlet /> */}
          </ScrollArea>
        </AppShell.Main>
      </AppShell>
    </MantineProvider>
  );
}

export default App;
