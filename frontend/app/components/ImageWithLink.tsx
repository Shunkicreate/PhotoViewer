import React from "react";

interface ImageWithLinkProps {
	image: {
		name: string;
		data?: string;
	};
	key: number;
}

const ImageWithLink: React.FC<ImageWithLinkProps> = ({ image, key }) => {
	return (
		<div key={key} className=''>
			<a href={`/${image.name}`} target='_blank' rel='noreferrer'>
				{image.data ? (
					<img src={`data:image/jpeg;base64,${image.data}`} alt={image.name} className='w-full h-auto object-cover' />
				) : (
					<div className='w-full h-48 flex items-center justify-center bg-gray-200 text-gray-700'>{image.name}</div>
				)}
			</a>
		</div>
	);
};

export default ImageWithLink;

