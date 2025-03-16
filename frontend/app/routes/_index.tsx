import { useLoaderData } from "@remix-run/react";
import { json } from "@remix-run/node";
import Loading from "~/components/Loading";
import ImageWithLink from "~/components/ImageWithLink";

interface ImageFile {
	path: string;
	name: string;
	size: number;
	width: number;
	height: number;
	data: string; // バイトデータはbase64エンコードされた文字列として受け取ります
}

interface LoaderData {
	files: string[];
	totalFiles: number;
	imageData: {
		name: string;
		data: string;
		width: number;
		height: number;
	}[];
}

const COUNT = 16;
const WIDTH = Math.floor(1920 / 4);
const HEIGHT = Math.floor(1080 / 4);
const ADDRESS = process.env.BACKEND_API_ADDRESS || "";

export const loader = async () => {
	try {
		const response = await fetch(`http://${ADDRESS}/top-photos?count=${COUNT}&width=${WIDTH}&height=${HEIGHT}`);
		if (!response.ok) {
			throw new Error(`API request failed: ${response.status}`);
		}

		const imageFiles: ImageFile[] = await response.json();
		return json(
			{
				files: imageFiles.map((file) => file.name),
				totalFiles: imageFiles.length,
				imageData: imageFiles.map((file) => ({
					name: file.name,
					data: file.data,
					width: file.width,
					height: file.height,
				})),
			},
			{ headers: { "Cache-Control": "public, max-age=600" } }
		);
	} catch (error) {
		console.error("Error fetching images:", error);
		return json({ error: "Failed to fetch images" }, { status: 500 });
	}
};

export default function Index() {
	const { imageData } = useLoaderData<LoaderData>();

	return (
		<div className='p-0 md:p-4'>
			{imageData?.length === 0 && <Loading />}
			<h1 className='text-2xl sm:text-3xl'>Photos</h1>
			<div className='mt-4 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-1'>
				{imageData?.map((image, i) => (
					<ImageWithLink key={i} image={image} />
				))}
			</div>
		</div>
	);
}
