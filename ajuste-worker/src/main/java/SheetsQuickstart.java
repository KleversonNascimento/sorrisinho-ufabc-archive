import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.sheets.v4.Sheets;
import com.google.api.services.sheets.v4.SheetsScopes;
import com.google.api.services.sheets.v4.model.ValueRange;

import java.io.*;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.security.GeneralSecurityException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class SheetsQuickstart {
    private static final String APPLICATION_NAME = "Google Sheets API Java Quickstart";
    private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
    private static final String TOKENS_DIRECTORY_PATH = "tokens";

    private static final List<String> SCOPES = Collections.singletonList(SheetsScopes.SPREADSHEETS);
    private static final String CREDENTIALS_FILE_PATH = "/credentials.json";


    public static Credential getCredentials(final NetHttpTransport HTTP_TRANSPORT) throws IOException {
        InputStream in = SheetsQuickstart.class.getResourceAsStream(CREDENTIALS_FILE_PATH);
        if (in == null) {
            throw new FileNotFoundException("Resource not found: " + CREDENTIALS_FILE_PATH);
        }
        GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(JSON_FACTORY, new InputStreamReader(in));


        GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow.Builder(
                HTTP_TRANSPORT, JSON_FACTORY, clientSecrets, SCOPES)
                .setDataStoreFactory(new FileDataStoreFactory(new java.io.File(TOKENS_DIRECTORY_PATH)))
                .setAccessType("offline")
                .build();
        LocalServerReceiver receiver = new LocalServerReceiver.Builder().setPort(8888).build();
        return new AuthorizationCodeInstalledApp(flow, receiver).authorize("user");
    }


    public static void addCell(String name, int vacancies, int requests) throws GeneralSecurityException, IOException {
        try {
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM HH:mm:ss");
            LocalDateTime now = LocalDateTime.now();

            final NetHttpTransport HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
            final String ajusteSheetId = "1ckpacd-c4WHQlPmsKqFD1hbWZN2zNeMsLNMdFkH-xvM";
            final String ajusteRange = "Vagas liberadas!A:D";
            System.out.println(getCredentials(HTTP_TRANSPORT).getExpiresInSeconds());
            Sheets service = new Sheets.Builder(HTTP_TRANSPORT, JSON_FACTORY, getCredentials(HTTP_TRANSPORT))
                    .setApplicationName(APPLICATION_NAME)
                    .build();

            ValueRange newRange = new ValueRange().setRange(ajusteRange).setValues(Arrays.asList(Arrays.asList(name, vacancies, requests, dtf.format(now))));
            service.spreadsheets().values().append(ajusteSheetId, ajusteRange, newRange).setValueInputOption("USER_ENTERED").execute();
        } catch (Exception ex) {
            System.out.println("Erro ao adicionar célula: " + name + ". Erro: " + ex);
        }
    }

    public static void sendToTelegram(String name, int vacancies, int requests) throws UnsupportedEncodingException {
        String urlString = "https://api.telegram.org/bot%s/sendMessage?chat_id=%s&parse_mode=HTML&text=%s";

        //Add Telegram token (given Token is fake)
        String apiToken = "token";

        //Add chatId (given chatId is fake)
        String chatId = "id";
        String text = "Vaga liberada na matéria: <b> " + name + " </b> \nVagas: <b>" + vacancies + "</b> \nRequisições: <b>" + requests + "</b>";

        String finalText = URLEncoder.encode(text, "UTF-8").replaceAll("\\+", "%20");

        urlString = String.format(urlString, apiToken, chatId, finalText);

        try {
            URL url = new URL(urlString);
            URLConnection conn = url.openConnection();
            InputStream is = new BufferedInputStream(conn.getInputStream());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
