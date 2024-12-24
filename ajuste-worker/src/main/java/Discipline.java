public class Discipline {
    final private int id;

    final private int vacancies;

    final private String name;

    final private String campus;

    private int requests;

    private boolean isFirstUpdate;

    Discipline(final int id, final int vacancies, final String name, final String campus) {
        this. id = id;
        this.vacancies = vacancies;
        this.name = name;
        this.campus = campus;
        this.requests = 0;
        this.isFirstUpdate = true;
    }

    public int getId() {
        return this.id;
    }

    public boolean getIsFirstUpdate() {
        return this.isFirstUpdate;
    }

    public int getRequests() {
        return requests;
    }

    public String getName() {
        return name;
    }

    public int getVacancies() {
        return vacancies;
    }

    public void setFirstUpdate(boolean firstUpdate) {
        this.isFirstUpdate = firstUpdate;
    }

    public void setRequests(int requests) {
        this.requests = requests;
    }
}
