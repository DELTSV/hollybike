import {
	RouterProvider, createBrowserRouter,
} from "react-router-dom";
import Login from "./auth/Login.tsx";
import {
	useEffect, useMemo, useState,
} from "preact/hooks";
import { useAuth } from "./auth/context.tsx";
import { useTheme } from "./theme/context.tsx";
import { Root } from "./Root.tsx";
import { Home } from "./home/Home.tsx";
import { clsx } from "clsx";
import { useSystemDarkMode } from "./utils/systemDarkMode.ts";
import { ListAssociations } from "./associations/listAssociations/ListAssociations.tsx";
import { Association } from "./associations/Association.tsx";
import { ListUser } from "./user/listUser/ListUser.tsx";
import { Conf } from "./conf/Conf.tsx";
import { UserDetail } from "./user/userDetail/UserDetail.tsx";
import { ListInvitations } from "./invitations/ListInvitations.tsx";
import { CreateInvitation } from "./invitations/CreateInvitation.tsx";
import { CreateAssociation } from "./associations/CreateAssociation.tsx";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { ListEvent } from "./events/ListEvent.tsx";
import { CreateEvent } from "./events/CreateEvent.tsx";
import { EventDetail } from "./events/EventDetail.tsx";
import { ListJourneys } from "./journey/ListJourneys.tsx";
import { JourneyView } from "./journey/JourneyView.tsx";
import { NewJourney } from "./journey/NewJourney.tsx";
import { useConfMode } from "./utils/useConfMode.tsx";
import { CGU } from "./page/CGU.tsx";
import { Invite } from "./page/Invite.tsx";
import { EventParticipantJourney } from "./events/EventParticipantJourney.tsx";

export function App() {
	const [loaded, setLoaded] = useState(false);
	const auth = useAuth();
	const theme = useTheme();
	const systemDark = useSystemDarkMode();
	const protectedRoute = useMemo(() => [
		{
			path: "/",
			element: <Home/>,
		},
		{
			path: "associations",
			element: <ListAssociations/>,
		},
		{
			path: "associations/new",
			element: <CreateAssociation/>,
		},
		{
			path: "associations/:id",
			element: <Association/>,
		},
		{
			path: "users",
			element: <ListUser/>,
		},
		{
			path: "users/:id",
			element: <UserDetail/>,
		},
		{
			path: "associations/:id/invitations",
			element: <ListInvitations/>,
		},
		{
			path: "associations/:id/users",
			element: <ListUser/>,
		},
		{
			path: "associations/:id/events",
			element: <ListEvent/>,
		},
		{
			path: "associations/:id/journeys",
			element: <ListJourneys/>,
		},
		{
			path: "invitations",
			element: <ListInvitations/>,
		},
		{
			path: "invitations/new",
			element: <CreateInvitation/>,
		},
		{
			path: "events",
			element: <ListEvent/>,
		},
		{
			path: "events/new",
			element: <CreateEvent/>,
		},
		{
			path: "events/:id",
			element: <EventDetail/>,
		},
		{
			path: "events/:id/participants/:idparticipant/journey",
			element: <EventParticipantJourney/>,
		},
		{
			path: "journeys",
			element: <ListJourneys/>,
		},
		{
			path: "journeys/view/:id",
			element: <JourneyView/>,
		},
		{
			path: "journeys/new",
			element: <NewJourney/>,
		},
		{
			path: "conf",
			element: <Conf/>,
		},
	], []);
	const router = createBrowserRouter([
		{
			path: "/",
			element: <Root/>,
			children: protectedRoute,
		},
		{
			path: "/login",
			element: <Login/>,
		},
		{
			path: "/forbidden",
			element: <p>"Interdit d'être ici"</p>,
		},
		{
			path: "/conf-mode",
			element: <Conf/>,
		},
		{
			path: "/privacy-policy",
			element: <CGU/>,
		},
		{
			path: "/invite",
			element: <Invite/>,
		},
	]);

	const { confMode } = useConfMode();

	useEffect(() => {
		if (!auth.loading) {
			setLoaded(true);
		}
	}, [auth.loading]);

	useEffect(() => {
		if (loaded) {
			if (confMode === false) {
				router.navigate("/conf-mode");
			} else if (!auth.isLoggedIn && protectedRoute.find(r => r.path == router.state.location.pathname) !== undefined) {
				router.navigate("/login");
			}
		}
	}, [
		confMode,
		auth.isLoggedIn,
		loaded,
	]);

	const themeDark = useMemo(() => theme.theme === "dark" || theme.theme === "os" && systemDark, [theme.theme]);

	return (
		<main
			className={clsx(themeDark && "dark", "bg-base w-screen h-screen text-text")}
		>
			<ToastContainer
				pauseOnHover={false}
				pauseOnFocusLoss={false}
				position={"top-right"}
				theme={themeDark ? "dark" : "light"}
			/>
			<RouterProvider router={ router } />
		</main>
	);
}
