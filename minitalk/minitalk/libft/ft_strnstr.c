/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strnstr.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rhanitra <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/02/27 09:58:33 by rhanitra          #+#    #+#             */
/*   Updated: 2024/02/27 09:58:42 by rhanitra         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdio.h>

char	*ft_strnstr(const char *big, const char *little, size_t len)
{
	size_t	i;
	size_t	j;

	i = 0;
	if (!*little)
		return ((char *)big);
	while (big[i] && len > 0)
	{
		j = 0;
		while (big[i + j] == little[j] && len > i + j)
		{
			if (little[j + 1] == '\0')
			{
				return ((char *)&big[i]);
				break ;
			}
			j++;
		}
		i++;
	}
	return (0);
}
