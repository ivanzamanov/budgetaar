import {
  AppShell,
  Container,
  MantineProvider,
  ScrollArea,
} from "@mantine/core";
import {
  BarElement,
  CategoryScale,
  Chart as ChartJS,
  Colors,
  LinearScale,
  LineElement,
  PointElement,
  Tooltip,
} from "chart.js";
import { Bar, Line } from "react-chartjs-2";
import "./App.css";
import MONTHLY from "./assets/monthly.json";

ChartJS.register(
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
      {
        label: "Baseline",
        backgroundColor: "Blue",
        data: MONTHLY.map((d) => ({
          x: d.date,
          y: 5500,
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
    maintainAspectRatio: false,
  };

  const width = MONTHLY.length * 45;
  const height = 300;
  return (
    <MantineProvider defaultColorScheme="light">
      <AppShell>
        <AppShell.Navbar p="md"></AppShell.Navbar>
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
          </ScrollArea>
        </AppShell.Main>
      </AppShell>
    </MantineProvider>
  );
}

export default App;
