import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main (String[] args) throws IOException {

        JSONArray allDisciplinesUnformatted = new JSONArray(getAllDisciplines());
        final List<Discipline> allDisciplines = new ArrayList<>();

        for (int i = 0; i < allDisciplinesUnformatted.length(); i++) {
            final JSONObject actualDiscipline = allDisciplinesUnformatted.getJSONObject(i);

            final Discipline newDiscipline = new Discipline(actualDiscipline.getInt("id"), actualDiscipline.getInt("vagas"), actualDiscipline.getString("nome"), actualDiscipline.getString("nome_campus"));

            allDisciplines.add(newDiscipline);
        }

        while (true) {
            try {
                final JSONObject requests = new JSONObject(getMatriculates());

                for (int i = 0; i < requests.length(); i++) {
                    try {
                        final Discipline currentDiscipline = allDisciplines.get(i);

                        if (!requests.isNull(String.valueOf(currentDiscipline.getId()))) {
                            final int newRequestsNumber = requests.getInt(String.valueOf(currentDiscipline.getId()));

                            if (currentDiscipline.getIsFirstUpdate()) {

                                currentDiscipline.setRequests(newRequestsNumber);

                                currentDiscipline.setFirstUpdate(false);
                            } else {
                                if (currentDiscipline.getRequests() != newRequestsNumber) {
                                    if (currentDiscipline.getRequests() > newRequestsNumber) {
                                        if (newRequestsNumber < currentDiscipline.getVacancies()) {
                                            SheetsQuickstart.addCell(currentDiscipline.getName(), currentDiscipline.getVacancies(), newRequestsNumber);
                                            SheetsQuickstart.sendToTelegram(currentDiscipline.getName(), currentDiscipline.getVacancies(), newRequestsNumber);
                                        }
                                    }
                                    currentDiscipline.setRequests(newRequestsNumber);
                                }
                            }
                        }
                    } catch (Exception ex) {
                        System.out.println("Disciplina: " + i + ". Erro: " + ex.toString());
                    }
                }

                Thread.sleep(500);
            } catch (Exception ex) {
                System.out.println(ex.toString());
            }
        }
    }

    private static String getAllDisciplines() throws IOException {
        URL url = new URL("https://matricula.ufabc.edu.br/cache/todasDisciplinas.js");
        URLConnection con = url.openConnection();

        BufferedReader in = new BufferedReader(new InputStreamReader(
                con.getInputStream()));
        String inputLine;
        String response = "";
        while ((inputLine = in.readLine()) != null) {
            response = response.concat(inputLine);
        }
        in.close();
        return response.replace("todasDisciplinas=", "");
    }

    private static String getMatriculates() throws IOException {
        URL url = new URL("https://matricula.ufabc.edu.br/cache/contagemMatriculas.js");
        URLConnection con = url.openConnection();

        BufferedReader in = new BufferedReader(new InputStreamReader(
                con.getInputStream()));
        String inputLine;
        String response = "";
        while ((inputLine = in.readLine()) != null) {
            response = response.concat(inputLine);
        }
        in.close();
        return response.replace("contagemMatriculas=", "");
    }
}
